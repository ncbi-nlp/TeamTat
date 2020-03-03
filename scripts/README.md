# pubqrator.rb : a script for downloading/uploading 



## Install

1. Get your **apikey**: please contact the person with administrator's priviliges.

2. Replace the key in the apikey file(**./apikey**) with your own.

3. Install missing libraries

   ```shell
   gem install httparty
   ```

4. Grant execute permission to the script, if you need
   ```shell
   chmod +x ./pubqrator.rb
   ```


​    

## Run

```shell
./pubqrator.rb
```



## Usage

```
Usage: pubqrator.rb COMMAND [options] {path} (or files for upload)

Commands:
   u / upload      Upload BioC files in the path to user's project
   d / download    Download documents in user's project into the path
   c / csv         List all annotations in user's project (to a csv file)

Options:
    -v, --[no-]verbose               Run verbosely
    -f, --[no-]force-upload          Upload duplicate documents even if they have the same PMID
    -H, --host=HOST                  Hostname for the server (default: www.teamtat.org)
    -P, --port=PORT                  Port number for the server (default: 443)
    -p, --protocol=protocol          Protocol name: https or http (default: https)
    -k, --keyfile=KEY_FILE_PATH      API key file path (default: ./apikey)
    -u, --user=USER_EMAIL            User email
    -U, --user_id=USER_ID            User ID
    -c, --prj=PROJECT_NAME           Project name (For uploading, create a new project when the name does not exist)
    -C, --prj_id=PROJECT_ID          Project ID
        --version_no=VERSION_NO      VERSION_NO
    -r, --[no-]replace               Remove documents with the same doucment id before uploading
        --[no-]new-project           For uploading, create a new project when it does not exist (default: true)
        --[no-]done-only             Search option for documents (done only)
        --[no-]curatable-only        Search option for documents (curatable only)
        --extra_infons=extra_infons  Extra infons for downloading csv (ex: updated_at,annotator)

Common options:
    -h, --help                       Show this message
        --version                    Show version

```

## Examples

``` shell
# Upload a single file './test1/abc.xml' into a project named 'A' of a user (user1@abc.com) 
./pubqrator.rb u -u user1@abc.com -c A ./test1/abc.xml

# Upload multiple files
./pubqrator.rb u -u user1@abc.com -c A ./test1/abc.xml ./test1/def.xml

# Upload files with a wildcard
./pubqrator.rb u -u user1@abc.com -c A ./test1/*
./pubqrator.rb u -u user1@abc.com -c A ./test1/a*.xml

# Upload all files in a directory (./test1) 
./pubqrator.rb u -u user1@abc.com -c A ./test1

# Duplicate(force) uploads with the same document id
./pubqrator.rb u -f -u user1@abc.com -c A ./test1/abc.xml

# Remove the existing one, and Upload the document
./pubqrator.rb u -f -r -u user1@abc.com -c A ./test1/abc.xml

# ------------------------------------------------------------------------

# Download all documents in a project into a directory
./pubqrator.rb d -u user1@abc.com -c A ./output

# Download 'done' documents only in a project into a directory
./pubqrator.rb d -u user1@abc.com -c A --done-only ./output

# Download documents of version 4 in project ID 6 into a directory
./pubqrator.rb d -C 6 --version_no=4 -u user1@abc.com -v temp

# ------------------------------------------------------------------------

# List all annotations in a project into as a csv file
./pubqrator.rb c -u user1@abc.com -p A ./output.csv


```

