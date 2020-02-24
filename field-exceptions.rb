#!/usr/bin/env ruby

require "./utils.rb"
include Utils





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
  rtcrow[key_num] = "" if rtcrow[key_num] == nil
  hash_key = rtcrow[key_num].strip
  if !hash.include?(hash_key)
    msg = rtctext+" value not in mapping. key:"+hash_key+",id:"+id+",moddate:"+rtcrow[1]
  else
    if jiratext =~ /jira user/
      if hash_key == "" && (jirarow[key_num] != "rtcuser" || jirarow[key_num] == "" || jirarow[key_num] == nil)
        msg = "Empty user should map to rtcuser or empty. Id:"+id
      end
    elsif hash[hash_key] == nil  
      msg = jiratext+" value not found. Key:#{hash_key},jira actual:"+ jirarow[key_num]+",id:"+id+",moddate:"+rtcrow[1]
  
    elsif jirarow[key_num] ==nil
      msg = jiratext+" not in mapping. Expected:Unknown,actual:Unknown,id:"+id+",moddate:"+rtcrow[1]
    elsif hash[hash_key].downcase.tr("()","") != jirarow[key_num].downcase.tr("()","")
      msg = jiratext+" doesn't match mapping. Key:#{hash_key} Expected:"+hash[hash_key]+",actual:"+ jirarow[key_num]+",id:"+id+",moddate:"+rtcrow[1]
    else
      #puts id+":"+hash[rtcrow[key_num]]+":"+jirarow[key_num]+":"+key_num.to_s
    end
  end
  if $debug
    p id
    p key_num
    p hash[hash_key]
    p jirarow[key_num]
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
      exit if i > 20
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
  # get RTC resolution
  #puts "Testing resolution field"
  if $args =~ /mapping/
    test_mappings(jirarow[idno],reso,$resolutions,rtcrow,jirarow,"rtc resolution","jira business impact")    
    # get RTC type
    test_mappings(jirarow[idno],type,$types,rtcrow,jirarow,"rtc type","jira type")
      # get RTC priority
    test_mappings(jirarow[idno],prio,$priorities,rtcrow,jirarow,"rtc priority","jira business impact")
    # get RTC severity
    test_mappings(jirarow[idno],seve,$severities,rtcrow,jirarow,"rtc severity","jira priority")
  end
    # get RTC component
  test_equals(jirarow[idno],cust,rtcrow,jirarow,"Customer") if $args =~ /customer/
  if $args =~ /date/
    #test_dates(jirarow[idno],dued,rtcrow,jirarow,"rtc due date","jira due date")
    test_dates(jirarow[idno],resd,rtcrow,jirarow,"rtc resolution date","jira resolved date")
  end

  # RTC user
  if $args =~ /user/
    #puts "user"
    test_mappings(jirarow[idno],assn,$users,rtcrow,jirarow,"rtc 'assigned to'","jira user")
    test_mappings(jirarow[idno],crby,$users,rtcrow,jirarow,"rtc 'created by'","jira user")
    test_mappings(jirarow[idno],qaow,$users,rtcrow,jirarow,"rtc qa owner","jira user")
  end


  # get RTC status
  if $args =~ /status/
    test_mappings(jirarow[idno],stat,$statuses,rtcrow,jirarow,"rtc status","jira status")
  end

  if $args =~ /component/
    test_mappings(jirarow[idno],comp,$components,rtcrow,jirarow,"rtc component","jira component")

  end
      # get RTC version
  if $args =~ /version/
    test_mappings(jirarow[idno],aver,$versions,rtcrow,jirarow,"rtc 'found in'","jira affected version")
    #test_mappings(jirarow[idno],fver,$versions,rtcrow,jirarow,"rtc 'planned for'","jira 'fixed version'")
    # get RTC browser

  end
  test_mappings(jirarow[idno],stat,$browsers,rtcrow,jirarow,"rtc browser","jira browser") if $args =~ /browser/
end

def main
  p $args = ARGV[0]
  $debug = ($args =~ /debug/)
  $rtcrows = read_rtc()
  $jirarows = read_jira()
  puts "rtc:"+$rtcrows.size.to_s
  puts "jira:"+$jirarows.size.to_s
  show_exceptions()
end

main()










#puts "Done"









