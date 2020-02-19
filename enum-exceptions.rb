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
def show_exceptions(rtcrows,jirarows)
  jirarows.each_pair{|id,jirarow|
    rtcrow = rtcrows[id]
    if rtcrow == nil
    else
      process_row(rtcrow,jirarow)
    end
  }
end

$jirarows = read_jira()
$rtcrows = read_rtc()
$resolutions = read_resolutions()
$statuses = read_status()
$types = read_type()
$priorities = read_priority()
$severities = read_severity()
$components = read_component()
$version = read_versions()

def process_row(rtcrow,jirarow)
  #puts id+":"+jirarow[0]+":"+rtcrow[2]+":"+rtcrow[3]
  idno = 0
  modd = 1
  reso = 2
  stat = 3
  type = 4
  prio = 5
  seve = 6
  comp = 7
  vers = 8

  p rtcrow
  id = jirarow[idno]
  # get RTC resolution
  rtcval = $resolutions[rtcrow[reso]]
  puts "rtc resolution not in mapping. Expected:#{rtcval},actual:"+rtcrow[reso] if rtcval == nil
  jiraval = $resolutions[rtcval]
  #test: mapping
  if jiraval == nil
    puts "jira resolution not in mapping. Expected:Unknown,actual:"+ jirarow[reso]
  elsif jiraval != jirarow[reso]
    puts "jira resolution doesn't match mapping. Expected:"+jiraval+",actual:"+ jirarow[reso]
  end
end

show_exceptions($rtcrows,$jirarows)







#puts "Done"









