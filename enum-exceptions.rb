#!/usr/bin/env ruby

$enums_file = "./enums.csv"

def read_jira() 
  rows = {}
  IO.read("jira2.csv").each_line {|line|
    array = line.strip().split(",")
    rows[array[0]] = array
  
  }
  return rows
end
def read_rtc()
  rows = {}
  IO.read("rtc2.csv").each_line {|line|
    array = line.strip().split(",")
    array
    rows[array[0]] = array
  
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

def init()

  $resolutions = read_resolutions()
  $statuses = read_status()
  $types = read_type()
  $priorities = read_priority()
  $severities = read_severity()
  $components = read_component()
  $version = read_versions()
end
def test_vals(id,rtckeyexists,rtcactual,jiraexpected,jiraactual,rtctext,jiratext)
  # get RTC resolution
  puts rtctext+" not in mapping. Expected:Unknown,actual:"+rtcactual if rtckeyexists
  #test: mapping
  if jiraexpected == nil
    puts jiratext+" not in mapping. Expected:Unknown,actual:"+ jiraactual
  elsif jiraexpected != jiraactual
    puts jiratext+" doesn't match mapping. Expected:"+jiraexpected+",actual:"+ jiraactual
  else
    puts id+" row ok."
  end
end
def show_exceptions()
  init()
  $jirarows.each_pair{|id,jirarow|
    rtcrow = $rtcrows[id]
    if rtcrow == nil
      puts "ID not found in RTC dataset: "+id
      p jirarow
    else
      process_row(rtcrow,jirarow)
    end
  }
end
def process_row(rtcrow,jirarow)

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
  p jirarow
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
  # get RTC priority
  test_vals(jirarow[idno],
    $types.include?(rtcrow[prio]),rtcrow[prio],
    $types[rtcrow[prio]],jirarow[prio],
    "rtc priority","jira priority")
  return
  # get RTC severity
  test_vals(jirarow[idno],
    $types.include?(rtcrow[seve]),rtcrow[seve],
    $types[rtcrow[seve]],jirarow[seve],
    "rtc severity","jira severity")
  # get RTC component
  test_vals(jirarow[idno],
    $types.include?(rtcrow[comp]),rtcrow[comp],
    $types[rtcrow[comp]],jirarow[comp],
    "rtc component","jira component")
  # get RTC version
  test_vals(jirarow[idno],
    $types.include?(rtcrow[vers]),rtcrow[vers],
    $types[rtcrow[vers]],jirarow[vers],
    "rtc version","jira version")
end

$rtcrows = read_rtc()
$jirarows = read_jira()
puts "rtc:"+$rtcrows.size.to_s
puts "jira:"+$jirarows.size.to_s
show_exceptions()







#puts "Done"









