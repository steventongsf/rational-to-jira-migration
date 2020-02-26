#!/usr/bin/env ruby

require "./utils.rb"
include Utils





def init()
  $browsers = read_browsers()
end
def show_exceptions()
  $notfound = 0
  $found = 0
  i = 0 
  init()
  $jirarows.each_pair{|id,jirarow|
    rtcrow = $rtcrows[id]
    if rtcrow == nil
      puts "ID not found in RTC dataset: "+id
      $notfound += 1
    else
      process_row(rtcrow,jirarow)
      $found += 1
    end
    i += 1
    if $debug
      exit if i > 20
    end
  }
end
def test_mappings(id,rtcpos,jirapos,hash,rtcrow,jirarow,rtctext,jiratext)
  msg = nil
  rtcrow[rtcpos] = "" if rtcrow[rtcpos] == nil
  hash_key = rtcrow[rtcpos].strip
  if !hash.include?(hash_key)
    msg = rtctext+" value not in mapping. key:"+hash_key+",id:"+id+",moddate:"+rtcrow[1]
  else
    if hash[hash_key] == nil  
      msg = jiratext+" value not found. Key:#{hash_key},jira actual:"+ jirarow[jirapos]+",id:"+id+",moddate:"+rtcrow[1]
    elsif (rtcrow[rtcpos] == nil || rtcrow[rtcpos] == "") && jirarow[jirapos] == nil
    elsif jirarow[jirapos] ==nil
      msg = jiratext+" not in mapping. Expected:Unknown,actual:Unknown,id:"+id+",moddate:"+rtcrow[1]
    elsif hash[hash_key].downcase.tr("()","") != jirarow[jirapos].downcase.tr("()","")
      msg = jiratext+" doesn't match mapping. Key:#{hash_key} Expected:"+hash[hash_key]+",actual:"+ jirarow[jirapos]+",id:"+id+",moddate:"+rtcrow[1]
    else
      #puts id+":"+hash[rtcrow[key_num]]+":"+jirarow[key_num]+":"+key_num.to_s
    end
  end
  if $debug
    p id
    p hash_key
    p hash[hash_key]
    p jirarow[jirapos]
    p rtcrow
    p jirarow
  end
  if msg != nil
    puts msg
    p rtcrow
    p jirarow
    return false
  end
  return true
end
s

def process_row(rtcrow,jirarow)
  #puts "testing row"
  #test_mappings(jirarow[0],2,2,$browsers,rtcrow,jirarow,"rtc 'browser'","jira browser")
  #test_dates(jirarow[0],2,rtcrow,jirarow,"rtc due date","jira due date")
  #test_dates(jirarow[0],3,rtcrow,jirarow,"rtc resolution date","jira resolved date")
  test_equals(jirarow[0],2,rtcrow,jirarow) # summary
end

def main
  p $args = ARGV[0]
  $debug = ($args =~ /debug/)
  $rtcrows = load_file("rtcsummary.csv")
  $jirarows = load_file("jirasummary.csv")
  puts "rtc:"+$rtcrows.size.to_s
  puts "jira:"+$jirarows.size.to_s
  puts "found:"+$found.to_s
  puts "not found:"+$notfound.to_s
  show_exceptions()
end

main()










#puts "Done"









