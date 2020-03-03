# json.partial! "projects/project", project: @project


status = @project.status

json.locked @project.locked
json.extract! @project, :id
json.status_with_icon @project.status_with_icon(status)
json.status status
json.busy @project.busy?(status)
json.task_available @project.task_available?(status)
json.has_annotations @project.has_annotations?