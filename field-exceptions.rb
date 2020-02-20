#!/usr/bin/env ruby

$enums_file = "./enums.csv"

def read_jira() 
  rows = {}
  IO.read("jira3.csv").each_line {|line|
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
def read_browsers() 
  return read_enum("Browser")
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

def init()

  $resolutions = read_resolutions()
  $statuses = read_status()
  $types = read_type()
  $priorities = read_priority()
  $severities = read_severity()
  $components = read_component()
  $versions = read_versions()
  $browsers = read_browsers()
  $users = read_users()
end
def test_mappings(id,key_num,hash,rtcrow,jirarow,rtctext,jiratext)
  msg = nil
  if !hash.include?(rtcrow[key_num])
    msg = rtctext+" not in mapping. actual:"+rtcrow[key_num]+",id:"+id+",moddate:"+rtcrow[1]
  end
  #test: mapping
  if hash[rtcrow[key_num]] == nil
    msg = jiratext+" not in mapping. Expected:Unknown,actual:"+ jirarow[key_num]+",id:"+id+",moddate:"+rtcrow[1]
  elsif hash[rtcrow[key_num]].downcase != jirarow[key_num].downcase
    msg = jiratext+" doesn't match mapping. Expected:"+hash[rtcrow[key_num]].downcase+",actual:"+ jirarow[key_num].downcase+",id:"+id+",moddate:"+rtcrow[1]
  else
    #puts id+":"+hash[rtcrow[key_num]]+":"+jirarow[key_num]+":"+key_num.to_s
  end
  if msg != nil
    puts msg
    p rtcrow
    p jirarow
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
      #puts "ID not found in RTC dataset: "+id
    else
      process_row(rtcrow,jirarow)
    end
    i += 1
    if $debug
      exit if i > 10
    end
  }
end
def process_row(rtcrow,jirarow)
  #puts "Processing row"
  idno = 0
  modd = 1
  reso = 2
  stat = 3
  type = 4
  prio = 5 #business impact
  seve = 6 #priority
  comp = 7 #filed against/component
  aver = 8 #found in/affected version
  fver = 9 #planned for/fixed version
  assn = 10 #owned by/ assignee
  crby = 11 #created by/reporter
  qaow = 12 # QA Owner
  cust = 13 #customer/customer
  dued = 14 # due date/due
  resd = 15 # resolution date/ resolved
  if $debug
    p rtcrow
    p jirarow
  end
  # get RTC user
  test_mappings(jirarow[idno],assn,$users,rtcrow,jirarow,"rtc user","jira user")
  return
  # get RTC resolution
  test_mappings(jirarow[idno],reso,$resolutions,rtcrow,jirarow,"rtc resolution","jira business impact")
  # get RTC status
  test_mappings(jirarow[idno],stat,$statuses,rtcrow,jirarow,"rtc status","jira status")
    # get RTC type
  test_mappings(jirarow[idno],type,$types,rtcrow,jirarow,"rtc type","jira type")
    # get RTC priority
  test_mappings(jirarow[idno],prio,$priorities,rtcrow,jirarow,"rtc priority","jira priority")
  # get RTC severity
  test_mappings(jirarow[idno],seve,$severities,rtcrow,jirarow,"rtc severity","jira priority")
    # get RTC component
  test_mappings(jirarow[idno],comp,$components,rtcrow,jirarow,"rtc component","jira component")
    # get RTC version
  test_mappings(jirarow[idno],aver,$versions,rtcrow,jirarow,"rtc version","jira version")
  test_mappings(jirarow[idno],fver,$versions,rtcrow,jirarow,"rtc version","jira version")
  test_mappings(jirarow[idno],assn,$versions,rtcrow,jirarow,"rtc owned by","jira assignee")
  test_mappings(jirarow[idno],crby,$versions,rtcrow,jirarow,"rtc created by","jira reporter")
  test_mappings(jirarow[idno],qaow,$versions,rtcrow,jirarow,"rtc QA Owner","jira QA Owner")
  # get RTC browser
  #test_mappings(jirarow[idno],stat,$browsers,rtcrow,jirarow,"rtc browser","jira browser")
  
end
$debug = false
$rtcrows = read_rtc()
$jirarows = read_jira()
puts "rtc:"+$rtcrows.size.to_s
puts "jira:"+$jirarows.size.to_s
show_exceptions()







#puts "Done"









