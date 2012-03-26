# Simple File.find by c00lryguy
# Thanks to justinwr for adding what I forgot to do
# ------------------------------
# Usage: 
#     * = wildcard in filename
#   File.find("E:\\") => All files in E:\
#   File.find("E:\\Ruby", "*.rb") => All .rb files in E:\Ruby
#   File.find("E:\\", "*.rb", false) => All .rb files in E:\, but not in its subdirs

class File
  
  def find(dir, filename="*.*", subdirs=true)
    Dir[ subdirs ? File.join(dir.split(/\\/), "**", filename) : File.join(dir.split(/\\/), filename) ]
  end

end