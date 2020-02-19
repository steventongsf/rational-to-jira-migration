#!/usr/bin/env ruby

$enums_file = "./enums.csv"

def read_jira() 
  rows = {}
  IO.read("jira.csv").each_line {|line|
    array = line.strip().split("|")
    rows[array[4]] = array
  
  }
  return rows
end
def read_rtc()
  rows = {}
  IO.read("rtc.csv").each_line {|line|
    array = line.strip().split(",")
    array
    rows[array[1]] = array
  
  }
  return rows
end

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





jirarows = read_jira()
rtcrows = read_rtc()
resolutions = read_resolutions()
p statuses = read_status()
p types = read_type()
p priorities = read_priority()
p severities = read_severity()
p components = read_component()
p version = read_versions()

def exceptions_old(rtcrows,jirarows)
  jirarows.each_pair{|id,jirarow|
    rtcrow = rtcrows[id]
    if rtcrow == nil
    else
      #puts id+":"+jirarow[0]+":"+rtcrow[2]
      if jirarow[0] == "To Do" && rtcrow[2] == "New"
      elsif jirarow[0] == "Done" && rtcrow[2] == "Done"
      elsif jirarow[0] == "Done" && rtcrow[2] == "Closed"
      elsif jirarow[0] == rtcrow[2]
      elsif jirarow[0] == "Done" && rtcrow[2] == "Resolved"
      elsif jirarow[0] == "Done" && rtcrow[2] == "Implemented"
      else
        #puts id+":"+jirarow[0]+":"+rtcrow[2]+":"+rtcrow[3]
      end
    end
    if rtcrow == nil
    else
      if jirarow[7] == rtcrow[7]
      else
        puts id+":"+jirarow[0]+":"+rtcrow[7]+":"+rtcrow[3]
      end
    end
  }
end
#puts "Done"
