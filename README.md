# rational-to-jira-migration
Tools used for a Rational to Jira Issue System Migration

Written using Ruby 2.3.7p456 on OSX

## field-exceptions.py ##
This script reports exceptions for various fields that have pre-defined values.  Currently, the script supports specific csv formats only.  The current format for the csv is (from the script):
'''
  type = 0 # issue type
  idno = 1
  assn = 2 #owned by/ assignee
  stat = 3 # status
  prio = 4 #priority/business impact
  seve = 5 #severity/priority
  modd = 6 # mod date/updated
  crby = 7 #created by/reporter
  cred = 8   #creation date/created
  cust = 9 #customer/customer
  dued = 10 # due date/due
  comp = 11 #filed against/component
  aver = 12 #found in/affected version
  fver = 13 #planned for/fixed version
  qaow = 14 # QA Owner
  reso = 15 # resolved by resolution
  resd = 16 # resolution date/ resolved
  brow = 17   #browser  
''' 
Please see script method process_row() for allowed command line arguments.
