require "commander"
require "json"

module Ngx
  VERSION  = "0.1.0"
  COMBINED = /(?<ip>\d+\.\d+\.\d+\.\d+)\s-\s(?<user>[\w|-]+)\s\[(?<day>\d+)\/(?<month>\w+)\/(?<year>\d+)\:(?<hour>\d+)\:(?<minute>\d+)\:(?<second>\d+)\s(?<timezone>\+\d+)\]\s\"(?<method>\w+)\s(?<path>[\/|\w]+)\s(?<protocol>\w+)\/(?<version>\d\.?\d?)\"\s(?<code>\d+)\s(?<bytes>\d+)\s\"(?<referer>[\w+|\W|+\d+])\"\s\"(?<user_agent>.*)\"/
  alias NgxStruct = Hash(String, String)

  cli = Commander::Command.new do |cmd|
    cmd.use  = "ngx"
    cmd.long = "Parser and filter for NGINX access logs from STDIN"

    cmd.flags.add do |flag|
      flag.name        = "mode"
      flag.short       = "-m"
      flag.long        = "--mode"
      flag.default     = "filter"
      flag.description = "filter: print only passed field values; find: print full string where was found passed values, "
    end

    cmd.flags.add do |flag|
      flag.name        = "fields"
      flag.short       = "-f"
      flag.long        = "--fields"
      flag.default     = "ip, code, path, referer"
      flag.description = "Set of required fields from logs. Can be used as \"ip, code\" or \"ip=127.0.0.1, code=404\", "
    end

    cmd.flags.add do |flag|
      flag.name        = "separator"
      flag.short       = "-s"
      flag.long        = "--separator"
      flag.default     = " "
      flag.description = "Separator for join fields on filter mode, "
    end

    cmd.flags.add do |flag|
      flag.name        = "output"
      flag.short       = "-o"
      flag.long        = "--output"
      flag.default     = "text"
      flag.description = "Print result as text or JSON, "
    end

    cmd.run do |opts, arguments|
      STDIN.each_line do |line|
        if match = line.match(COMBINED)

          if opts.string["mode"] == "find"
            fields = opts.string["fields"].split(",").map{|f| f.strip.downcase }.map{|field| field.split("=") }.to_h
            result = match.named_captures.select(fields.keys)
            if fields == result
              puts match.named_captures.to_h.to_json if fields == result && opts.string["output"] == "json"
              puts line if fields == result && opts.string["output"] == "text"
            end
          end

          if opts.string["mode"] == "filter"
            fields = opts.string["fields"].split(",").map{|f| f.strip.downcase }
            result = match.named_captures.select(fields)
            puts result.to_json if opts.string["output"] == "json"
            puts result.values.join(opts.string["separator"]) if opts.string["output"] == "text"
          end

        end
      end
    end
  end

  Commander.run(cli, ARGV)
end