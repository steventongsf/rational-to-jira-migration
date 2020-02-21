module Utils
  def read_jira() 
    rows = {}
    IO.read("jira3.csv").each_line {|line|
      array = line.strip().split(",")
      array.each {|el|
        el = el.gsub("\"","")
      }
      if array[0].to_i > 0
        rows[array[0]] = array
      end
    
    }
    return rows
  end
  def read_rtc()
    rows = {}
    IO.read("rtc3.csv").each_line {|line|
      array = line.strip().split(",")
      array
      rows[array[0]] = array
    
    }
    return rows
  end
  $enums_file = "./enums.csv"
  
  
  def read_enum(category) 
    hash = {}
    IO.read($enums_file).each_line {|line|
      array = line.split(",")
      if array[0].strip() == category
        hash[array[1].strip] = array[2].strip
      end
    }
    return hash
  end
  def read_component() 
    hash = {}
    IO.read("components.csv").each_line {|line|
      array = line.split(",")
      hash[array[0].strip] = array[1].strip
    }
    return hash
  end
  def read_versions() 
    hash = {}
    IO.read("versions.csv").each_line {|line|
      array = line.split(",")
      hash[array[0].strip] = array[1].strip
    }
    return hash
  end
  def read_users() 
    hash = {}
    IO.read("users.csv").each_line {|line|
      array = line.split(",")
      hash[array[0].strip.gsub("\"","")] = array[2].strip.gsub("\"","")
    }
    return hash
  end
  def read_resolutions() 
    return read_enum("Resolution")
  end
  def read_status() 
    return read_enum("Status")
  end
  def read_type() 
    return read_enum("Type")
  end
  def read_priority() 
    return read_enum("Priority")
  end
  def read_severity() 
    return read_enum("Severity")
  end
  def read_browsers() 
    return read_enum("Browser")
  end
end