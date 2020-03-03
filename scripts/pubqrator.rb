#!/usr/bin/env ruby
Version = [1, 0, 0]

require 'optparse'
require 'ostruct'
require 'httparty'
require 'rest-client'
require 'csv'
require 'pp'

class PubQRator
  include HTTParty
  attr_reader :options
  format :json

  def verbose_puts(str)
    puts str if @options.verbose
  end

  def verify_command
    if @command.nil? || !%w(u d upload download csv c pmcid).include?(@command.downcase)
      STDERR.puts "Error: unknown command '#{@command}'"
      exit
    else
      @command = @command.downcase
      @command = "upload" if @command == "u"
      @command = "download" if @command == "d"
      @command = "csv" if @command == "c"
    end
    verbose_puts "Command : #{@command}" 
  end

  def verify_path_download
    if @path.nil? || @path.empty? || @path.size != 1
      STDERR.puts "Error: You should specify a path"
      exit
    end
    @path = @path[0]
    if @path.nil? || !File.exist?(@path)
      STDERR.puts "Error: path (#{@path}) does not exist"
      exit
    end

    if !File.directory?(@path)
      STDERR.puts "Error: path (#{@path}) is not directory"
      exit
    end
    verbose_puts "Path : #{@path}" 
  end

  def verify_path_csv
    if @path.nil? || @path.empty? || @path.size != 1
      STDERR.puts "Error: You should specify a path for the output file"
      exit
    end
    @path = @path[0]

    if File.directory?(@path)
      @path = File.join(@path, "#{@options.project_name || @options.project_id}.csv")
    end

    if @path.nil? || File.exist?(@path)
      STDERR.puts "Error: the file(#{@path}) already exists"
      exit
    end

    verbose_puts "Path : #{@path}" 
  end

  def verify_path_upload
    if @path.nil? || @path.empty? 
      STDERR.puts "Error: You should specify files or pathname"
      exit
    end
    if @path.size == 1 && File.exist?(@path[0]) && File.directory?(@path[0])
      pathname = @path[0]
      @path = []
      Dir[File.join(pathname, "*.xml")].each do |filename|
        @path << filename
      end
    end
    if @path.size == 1 && !File.exist?(@path[0])
      STDERR.puts "Error: path (#{@path}) is not directory"
      exit
    end
    verbose_puts "Path : #{@path}" 
  end

  def load_keyfile
    begin
      @key = File.open(@options.keyfile, &:readline)
    rescue Errno::ENOENT
      STDERR.puts "Error: keyfile '#{@options.keyfile}' does not exist"
      exit
    end
    verbose_puts "API Key : #{@key}" 
  end

  def init_http_request
    @uri = "#{@options.protocol}://#{@options.host}:#{@options.port}"
    self.class.base_uri @uri
    self.class.headers 'Accept' => 'application/json'
    self.class.headers 'Content-Type' => 'application/json'
    self.class.headers 'x-api-key' => @key
    @headers = {
      "Accept" => "application/json",
      "x-api-key" => @key
    }
    verbose_puts "URI : #{@uri}" 
  end

  def verify_user_project
    get_user unless @options.email.nil? 
    if @options.user_id.nil?
      STDERR.puts "Error: user id or email is required"
      exit
    end
    verbose_puts "User : #{@options.user_id}" 

    get_project unless @options.project_name.nil? 
    verbose_puts "Project : #{@options.project_id}" 
  end

  def download_file(did, url)
    fullpath = File.join(@path, "#{did}.xml")
    if !@options.version_no.nil?
      url = url + "?version=#{@options.version_no}"
    end

    puts "Download <#{@uri}#{url}> to <#{fullpath}>"
    File.open(fullpath, "w") do |file|
      file.binmode
      begin
        self.class.get(url, stream_body: true) do |fragment|
          file.write(fragment)
        end
      rescue Exception => e
        STDERR.puts "Error: #{e.message}"
        exit
      end
    end
    @success += 1
  end

  def download_csv(id)
    url = "/documents/#{id}/annotations"
    if !@options.version_no.nil?
      url = url + "?version=#{@options.version_no}"
    end
    puts "List annotations from <#{@uri}#{url}>"
    response = []
    begin
      response = self.class.get(url)
    rescue Exception => e
      STDERR.puts "Error: #{e.message}"
      exit
    end
    @success += 1
    return response.to_a
  end

  def initialize(args)
    @success = 0
    self.parse(args)
    verbose_puts "Option: #{@options.to_h}"
    @command = args[0]
    @path = args[1..-1]
    verify_command
    load_keyfile

    init_http_request
    verify_user_project
  end

  def download
    verify_path_download
    documents = get_documents
    documents.each do |d|
      download_file(d[:did], d[:url])
    end
  end

  def list_annotations_csv
    verify_path_csv
    documents = get_documents
    extra_infons = @options.extra_infons.split(',')

    CSV.open(@path, "w") do |csv|
      header = ["did", "type", "concept", "text", "annotator", "offset", "length", "updated_at"]
      csv << header + extra_infons
      documents.each do |d|
        download_csv(d[:id]).each do |a|
          infons = a["infons"] || {}
          line = [a["did"], infons["type"], infons["identifier"], a["text"], infons["annotator"], a["offset"], a["length"], infons["updated_at"]]
          extra_infons.each do |name|
            line << infons[name] || ""
          end
          csv << line
        end
      end
    end
  end

  def upload_file(filename)
    did = File.basename(filename, ".xml")
    if !@options.force_upload
      verbose_puts "  > Checking DID #{did} exist?..."
      begin
        response = self.class.get("/projects/#{@options.project_id}/documents", query: {did: did})
      rescue Exception => e
        STDERR.puts "Error: #{e.message}"
        exit
      end

      if !response.to_a.empty?
        puts "Skip <#{filename}>"
        return
      end
    end
    puts "Upload <#{filename}> to <#{@uri}/projects/#{@options.project_id}/documents>"
    params = {file: File.new(filename, 'rb')}
    params[:replace] = did if @options.replace
    RestClient.post("#{@uri}/projects/#{@options.project_id}/documents",  
      params, headers = @headers
    ) do |response, request, result|
      if response.code >= 300
        STDERR.puts  "   > Error: #{response.code} #{response.body}"
      end
    end
    @success += 1
  end

  def upload
    verify_path_upload
    verbose_puts @options.inspect
    verbose_puts "Upload..."
    @path.each do |filename|
      upload_file(filename)
    end
  end

  def correct_pmc_id
    documents = get_documents
    documents.each do |d|
      url = "/documents/#{d[:id]}/correct_pmc_id"
      puts "Try to fix pmc_id from <#{@uri}#{url}>"
      begin
        response = self.class.get(url)
      rescue Exception => e
        STDERR.puts "Error: #{e.message}"
        exit
      end
      @success += 1
    end
  end

  def run
    if @command == "download"
      self.download
    elsif @command == "upload"
      self.upload
    elsif @command == "csv"
      self.list_annotations_csv
    elsif @command == "pmcid"
      self.correct_pmc_id
    end

    puts "Total #{@success} files have been transfered or processed"
  end

  def get_user
    verbose_puts "> HTTP Get /users?email=#{@options.email}"
    begin
      response = self.class.get('/users', {query: {email: @options.email}})
    rescue Exception => e
      STDERR.puts "Error: #{e.message}"
      exit
    end
    verbose_puts "  --> Response #{response.code}"
    if response.code == 401
      STDERR.puts "Error: your apikey does not exist."
      exit
    end

    if response.to_a.empty? 
      STDERR.puts "Error: email(#{@options.email}) does not exist or is not accessible to you"
      exit
    end
    user = response.to_a[0]
    if !@options.user_id.nil? && user["id"] != @options.user_id
      STDERR.puts "Error: user's id(#{@options.user_id}) and email(#{@options.email}) do not match"
      exit
    end
    @options.user_id = user["id"]
  end

  def get_project
    verbose_puts "> HTTP Get /users/#{@options.user_id}/projects"
    begin
      response = self.class.get("/users/#{@options.user_id}/projects", {query: {name: @options.project_name}})
    rescue Exception => e
      STDERR.puts "Error: #{e.message}"
      exit
    end

    verbose_puts "  --> Response #{response.code}: #{response.to_a.inspect}"
    if response.to_a.empty? 
      if @options.new_project && @command == "upload" 
        verbose_puts "  Try to create: HTTP POST /users/#{@options.user_id}/projects"
        begin
          response = self.class.post("/users/#{@options.user_id}/projects", {
            body: {project: {name: @options.project_name }}.to_json
          })
        rescue Exception => e
          STDERR.puts "Error: #{e.message}"
          exit
        end
        verbose_puts "  --> Response #{response.code}: #{response.parsed_response.inspect}"
        project = response.parsed_response
      else
        STDERR.puts "Error: project(#{@options.project_name}) does not exist or is not accessible to you"
        exit
      end
    elsif response.to_a.size > 1 
      STDERR.puts "Error: there are multiple projects with the same name (#{@options.project_name})"
      exit
    else
      project = response.to_a[0]
      if !@options.project_id.nil? && project["id"] != @options.project_id
        STDERR.puts "Error: project's id(#{@options.project_id}) and name(#{@options.project_name}) do not match"
        exit
      end
    end
    @options.project_id = project["id"]
  end
  
  def get_documents
    verbose_puts "> HTTP Get /projects/#{@options.project_id}/documents"
    begin
      response = self.class.get("/projects/#{@options.project_id}/documents", query: @options.search_options)
    rescue Exception => e
      STDERR.puts "Error: #{e.message}"
      exit
    end

    verbose_puts "  --> Response #{response.code}: #{response.to_a.inspect}"
    if response.code >= 400
      STDERR.puts "ERROR: #{response.to_a.inspect}"
      @documents = []
    else
      @documents = response.to_a.map{|d| {id: d["id"], did: d["did"], url: "/documents/#{d["id"]}.xml"}}
    end
  end

  def parse(args)
    @options = OpenStruct.new
    @options.verbose = false
    @options.host = "www.teamtat.org"
    @options.port = 443
    @options.keyfile = "./apikey"
    @options.force_upload = false
    @options.replace = false
    @options.search_options = {}
    @options.protocol = "https"
    @options.extra_infons = ""
    @options.new_project = true
    @options.version_no = nil
    opt_parser = OptionParser.new do |opts|

      opts.banner = "Usage: pubqrator.rb COMMAND [options] {path} (or files for upload)"

      opts.separator ""
      opts.separator "Commands:"
      opts.separator "   u / upload      Upload BioC files in the path to user's project"
      opts.separator "   d / download    Download documents in user's project into the path"
      opts.separator "   c / csv         List all annotations in user's project (to a csv file)"
      opts.separator ""
      opts.separator "Options:"

      # Boolean switch.
      opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        @options.verbose = v
      end

      opts.on("-f", "--[no-]force-upload", "Upload duplicate documents even if they have the same PMID") do |v|
        @options.force_upload = v
      end

      opts.on("-H", "--host=HOST", "Hostname for the server (default: www.teamtat.org)") do |v|
        @options.host = v
      end

      opts.on("-P", "--port=PORT", Integer, "Port number for the server (default: 443)") do |v|
        @options.port = v
      end

      opts.on("-p", "--protocol=protocol", "Protocol name: https or http (default: https)") do |v|
        @options.protocol = v
      end

      opts.on("-k", "--keyfile=KEY_FILE_PATH", "API key file path (default: ./apikey)") do |v|
        @options.keyfile = v
      end

      opts.on('-u', '--user=USER_EMAIL', "User email") do |email|
        @options.email = email
      end

      opts.on('-U', '--user_id=USER_ID', Integer, "User ID") do |id|
        @options.user_id = id
      end

      opts.on('-c', '--prj=PROJECT_NAME', "Project name (For uploading, create a new project when the name does not exist)") do |name|
        @options.project_name = name
      end

      opts.on('-C', '--prj_id=PROJECT_ID', Integer, "Project ID") do |id|
        @options.project_id = id
      end

      opts.on('--version_no=VERSION_NO', Integer, "VERSION_NO") do |id|
        @options.version_no = id
      end

      opts.on("-r", "--[no-]replace", "Remove documents with the same doucment id before uploading") do |v|
        @options.replace = v
      end

      opts.on("--[no-]new-project", "For uploading, create a new project when it does not exist (default: true)") do |v|
        @options.new_project = v
      end

      opts.on("--[no-]done-only", "Search option for documents (done only)") do |v|
        @options.search_options[:done] = v
      end

      opts.on("--[no-]curatable-only", "Search option for documents (curatable only)") do |v|
        @options.search_options[:curatable] = v
      end

      opts.on("--extra_infons=extra_infons", "Extra infons for downloading csv (ex: updated_at,annotator)") do |v|
        @options.extra_infons = v
      end

      opts.separator ""
      opts.separator "Common options:"
      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
        # Another typical switch to print the version.
      opts.on_tail("--version", "Show version") do
        puts ::Version.join('.')
        exit
      end
    end
    args << '-h' if args.empty?
    begin
      opt_parser.parse!(args)
    rescue Exception => e
      STDERR.puts "Error: #{e.message}" if e.message != 'exit'
      exit
    end
    @options
  end

end

pubqrator = PubQRator.new(ARGV)
pubqrator.run
