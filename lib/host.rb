# frozen_string_literal: true

class Hosts
  @host_list = ["melchior", "balthasar", "casper"]

  class << self
    def from_env
      hosts = ENV.fetch("HOSTS")
      return @host_list if hosts == "all"
      hosts = hosts.split(",")
      hosts.each do |host|
        host.strip!
        abort "hostname not in list" unless @host_list.include? host
      end
      hosts
    end
  end
end
