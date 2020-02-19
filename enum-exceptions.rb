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

def test_vals(id,rtckeyexists,rtcactual,jiraexpected,jiraactual,rtctext,jiratext)
  # get RTC resolution
  puts rtctext+" not in mapping. Expected:Unknown,actual:"+rtcactual if rtckeyexists
  #test: mapping
  if jiraexpected == nil
    puts jiratext+" not in mapping. Expected:Unknown,actual:"+ jiraactual
  elsif jiraexpected != jiraactual
    puts jiratext+" doesn't match mapping. Expected:"+jiraexpected+",actual:"+ jiraactual
  end
end
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
  # get RTC resolution
  test_vals(jirarow[idno],
    $resolutions.include?(rtcrow[reso]),rtcrow[reso],
    $resolutions[rtcrow[reso]],jirarow[reso],
    "rtc resolution","jira resolution")
  # get RTC status
  test_vals(jirarow[idno],
    $statuses.include?(rtcrow[stat]),rtcrow[stat],
    $statuses[rtcrow[stat]],jirarow[stat],
    "rtc status","jira status")
  # get RTC type
  test_vals(jirarow[idno],
    $types.include?(rtcrow[type]),rtcrow[type],
    $types[rtcrow[type]],jirarow[type],
    "rtc type","jira type")
end

show_exceptions($rtcrows,$jirarows)







#puts "Done"









