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
  IO.read("rtc3.csv").each_line {|line|
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
def test_mappings(id,key_num,hash,rtcrow,jirarow,rtctext,jiratext)
  msg = nil
  if !hash.include?(rtcrow[key_num])
    msg = rtctext+" not in mapping. actual:"+rtcrow[key_num]+",id:"+id
    return
  end
  #test: mapping
  if hash[rtcrow[key_num]] == nil
    msg = jiratext+" not in mapping. Expected:Unknown,actual:"+ jirarow[key_num]+",id:"+id
  elsif hash[rtcrow[key_num]] != jirarow[key_num]
    msg = jiratext+" doesn't match mapping. Expected:"+hash[rtcrow[key_num]]+",actual:"+ jirarow[key_num]+",id:"+id
  else
    #puts id+" row ok."
  end
  if msg != nil
    puts msg
    return false
  end
  return true
end
def test_vals(id,rtckeyexists,rtcactual,jiraexpected,jiraactual,rtctext,jiratext)
  msg = nil
  if !rtckeyexists
    msg = rtctext+" not in mapping. actual:"+rtcactual+",id:"+id
    return
  end
  #test: mapping
  if jiraexpected == nil
    msg = jiratext+" not in mapping. Expected:Unknown,actual:"+ jiraactual+",id:"+id
  elsif jiraexpected != jiraactual
    msg = jiratext+" doesn't match mapping. Expected:"+jiraexpected+",actual:"+ jiraactual+",id:"+id
  else
    #puts id+" row ok."
  end
  if msg != nil
    puts msg
    return false
  end
  return true
end
def show_exceptions()
  i = 0 
  init()
  $jirarows.each_pair{|id,jirarow|
    rtcrow = $rtcrows[id]
    if rtcrow == nil
      puts "ID not found in RTC dataset: "+id
    else
      process_row(rtcrow,jirarow)
    end
    i += 1
    if $debug
      exit if i > 5
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
  if $debug
    p rtcrow
    p jirarow
  end
  # get RTC resolution
  test_mappings(jirarow[idno],reso,$resolutions,rtcrow,jirarow,"rtc resolution","jira resolution")

return
  # get RTC status

  # get RTC type

  # get RTC priority


  # get RTC severity

  # get RTC component

  # get RTC version

end
$DEBUG = true
$rtcrows = read_rtc()
$jirarows = read_jira()
puts "rtc:"+$rtcrows.size.to_s
puts "jira:"+$jirarows.size.to_s
show_exceptions()







#puts "Done"








