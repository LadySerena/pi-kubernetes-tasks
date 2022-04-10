# frozen_string_literal: true

require "google/cloud/storage"
require_relative "../lib/host"

namespace :image do
  desc "generate ssh host keys HOSTS="
  task :hostkeys do
    host = Hosts.from_env
    create_keys(host)
  end

  desc "upload host keys to gcp (cloud storage for pub keys and secret manager for private keys) HOSTS="
  task :upload_keys do
    host = Hosts.from_env
    upload_to_gcp(host)
  end

  private

  def create_keys(hosts)
    key_types = ["dsa", "rsa", "ecdsa", "ed25519"].freeze
    hosts.each do |host|
      Dir.mkdir "#{host}_host_key"
      key_types.each { |type| `ssh-keygen -C "host key for #{host}" -q -N "" -t #{type} -f #{host}_host_key/ssh_host_#{type}_key` }
    end
  end

  def upload_to_gcp(hosts)
    storage = Google::Cloud::Storage.new(
      project_id: "telvanni-platform",
    )

    bucket = storage.bucket "pi-host-keys.serenacodes.com"

    hosts.each do |host|
      secret_name = "#{host}-host-key"
      archive_directory("#{host}_host_key", secret_name)

      bucket.create_file "#{secret_name}.tar.gz", "#{secret_name}.tar.gz"
    end
  end

  def archive_directory(dir_path, archive_name)
    `tar -czf #{archive_name}.tar.gz #{dir_path}`
  end

  def convert_to_secret_manager_name(name)
    name.tr("_", "-").tr("/", "0")
  end

  def convert_to_file_name(name)
    name.tr("-", "_").tr("0", "/")
  end
end
