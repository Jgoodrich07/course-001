require 'etc'

class FileInfo

  MODES = { "0" => "---", "1" => "--x", "2" => "-w-", "3" => "-wx",
            "4" => "r--", "5" => "r-x", "6" => "rw-", "7" => "rwx"}

  def initialize(file)
    @file = file
    @stats = File::Stat.new(file)
  end

  def permissions
    permission_string(@stats.mode)
  end

  def size
    File.size(@file)
  end

  def name
    @file
  end

  def links
    @stats.nlink
  end

  def group_name
    begin
      Etc.getgrgid(@stats.gid).name
    raise ArgumentError
    rescue
      @stats.gid
    end
  end

  def owner_name
    Etc.getpwuid(@stats.uid).name
  end

  def mod_time
    @stats.mtime.strftime("%b %e %H:%M")
  end

  def permission_string(number)
    # still don't really understand the [ ] function for a fixnum
    dir_mark = number[15] == 0 ? "d" : "-"
    # this standardizes the number as an octal and makes it into an array
    codes = (number & 0777).to_s(8).chars
    dir_mark + codes.map {|n| MODES[n]}.join
  end

end
