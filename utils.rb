module Utils
  def load_file(fname) 
    rows = {}
    IO.read(fname).each_line {|line|
      array = line.strip().split(",")
      array.each {|el|
        el = el.gsub("\"","")
      }
      #if array[0].to_i > 0 and array.size >= 16
        rows[array[0]] = array if array.size == 4
      #end
    
    }
    return rows
  end
def load_csv(fname,fieldcnt) 
  rows = {}
  IO.read(fname).each_line {|line|
    #p line
    array = line.strip().split(",")
    array.each {|el|
      el = el.gsub("\"","")
    }
    if array[1].to_i > 0 and array.size >= 16
      rows[array[1]] = array
    end
  }
  return rows
end
def load_tsv(fname,fieldcount) 
  rows = {}
  IO.read(fname).each_line {|line|
    #p line
    array = line.strip().split("\t")
    array.each {|el|
      el = el.gsub("\"","")
    }
    #if array[0].to_i > 0 and array.size >= 16
      rows[array[1]] = array if array.size == fieldcount
    #end
  
  }
  return rows
end
  def read_jira() 
    rows = {}
    IO.read("jira3.csv").each_line {|line|
      array = line.strip().split(",")
      array.each {|el|
        el = el.gsub("\"","")
      }
      if array[0].to_i > 0 and array.size >= 16
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
  def test_equals(id,key_num,rtcrow,jirarow,name)
    rtc = rtcrow[key_num]
    jira = jirarow[key_num]
    rtc = "" if rtc == nil
    jira = "" if jira == nil
    if jira.downcase.tr('()','') =~ /#{rtc.downcase.tr('()','')}/
    else
      puts "rtc field #{name} doesn't match jira value. Expected:#{rtc},Actual:#{jira}"
      p rtcrow
      p jirarow
    end
  end
  def key_exist?(hash,actual)
    hash.each_pair {|k,v|
      if actual.downcase =~ /#{k.downcase}/
        return true
      end
    }
    return false
  end
  def parse_date(str)
     array = str.split(" ")[0].split("/")
     return Date.parse(array[2]+"-"+array[0]+"-"+array[1])
  end
  def test_dates(id,colpos,rtcrow,jirarow,rtctext,jiratext)
    require 'date'
    msg = nil
    if rtcrow[colpos] == nil || rtcrow[colpos] == ""
      return false
    else
      rtcdate = parse_date(rtcrow[colpos])
      if jirarow[colpos] == nil || jirarow[colpos] == ""
        msg = jiratext+" not migrated. Expected:"+rtcrow[colpos]+",actual:,id:"+id+",moddate:"+rtcrow[1]
      else
        begin
          jiradate = Date.parse(jirarow[colpos])
        rescue
          msg = jiratext+" not migrated. Expected:"+rtcrow[colpos]+",actual:NA,id:"+id+",moddate:"+rtcrow[1]
        else
          if (jiradate - rtcdate <= 1)
          else
            p jiradate - rtcdate <= 1
            msg = jiratext+" value doesn't match RTC value. Expected:"+rtcrow[colpos]+",actual:"+ jirarow[colpos]+",id:"+id+",moddate:"+rtcrow[1]
          end
        end
      end
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
def cleanstr(str)
  str = str.gsub("\"","")
  if str =~ /^RTC/
    str = str.split(" ",2)[1]
  end
  return str.strip
end
def test_equals(id,pos,rtcrow,jirarow) 
  rtc = cleanstr(rtcrow[pos])
  jira = cleanstr(jirarow[pos])
  if jira != rtc
    msg = "summary field doesn't match id:#{id}"
  end
  if msg != nil
    puts msg
    p rtc
    p jira
    p rtcrow
    p jirarow
    return false
  end
end
end