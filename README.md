#wmls WITSML command line tool in Ruby

Use this script to call GetCap, GetFromStore, AddToStore, UpdateInStore, or DeleteFromStore on 
a WITSML server.

##Install
Make sure you've [installed Ruby](https://www.ruby-lang.org/en/downloads/). Then

```
gem install wmls
```
After install, the wmls command should be on your path. It uses lib/wmls.rb, a library you can use to write your own WITSML programs, which is installed as part of this gem.



##Usage

    wmls [options]
    -Dvariable=value                 Replace occurrences of %variable% with value, in the query template  
    -v, --verbose                    Run verbosely  
    -r, --url url                    URL of the WITSML service  
    -t, --timeout seconds            timeout in seconds (optional, default 60)  
    -u, --username USER              HTTP user name  
    -p, --password PASS              HTTP password  
    -q, --query QUERYFILE            Path to file containing query, delete, add or update template  
    -a, --action  cap|get|add|update|delete     WITSML action; default is 'get'  
    -o, --optionsin OPTIONSIN        optionsIn string (optional)      
    -h, --help                       Show this message  


##Example

```
  wmls -q query_v1311/get_all_wells.xml -r https://yourserver.com/witsml -u username -p mypassword -a get
```

I've included a bunch of sample query templates originally created by Gary Masters of Energistics.
You can obtain them by downloading the source zip at
  https://github.com/wellstorm/wmls/archive/master.zip
The templates contain variables delimited by % characters, e.g. "%uidWellbore%".
Inspect the templates you want to use to determine the variables you need to replace.
Pass substitution values for these values on the wmls command line, e.g:

```
  wmls -DuidWell=ABC -DuidWellbore=1234 -q...
```

##License
Apache 2.0

##History

10 Mar 2011 -- initial commit.  
16 Oct 2011 -- added -D option to wmls command line tool  (0.1.7)  
01 May 2012 -- added GetCap support (0.1.8)  
01 May 2012 -- added support for capabilitiesIn parameter to all calls (0.1.9)  
04 May 2012 -- added support for a headers parameter to all calls (0.1.11)    
07 May 2012 -- fix headers param to get_cap (default should be {}) (0.1.13)  
14 Jun 2012 -- return values to shell from wmls script (0.1.14)    
14 Aug 2012 -- add timeout option to wmls script (0.1.15)  
18 Jul 2015 -- replace REXML with nokogiri, and fix missing endDateTimeIndex (0.1.16)   (thanks emre.demirors and alex.bednarczyk)  
21 Jul 2015 -- revert back to REXML. (nokogiri install too fragile) (0.1.18)  (do not install this version)  
19 Apr 2016 -- revert back to 0.1.15 plus endDateTimeIndex fix (1.0.0)  
20 Apr 2016 -- enlarge REXML parameter to permit parsing up to 1GB responses (1.0.1)  
20 Apr 2016 -- really support -v parameter, for verbose diagnostics (1.0.2)  
04 Apr 2022 -- Remove shebang, require ruby >= 2.7.5 (1.0.3)  

[![Gem Version](https://badge.fury.io/rb/wmls.svg)](https://badge.fury.io/rb/wmls)
