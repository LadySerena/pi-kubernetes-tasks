# frozen_string_literal: true

require "google/cloud/storage"
require "google-cloud-secret_manager"

namespace :image do
  desc "generate ssh host keys HOST="
  task :hostkeys do
    host = ENV.fetch("HOST")
    key_types = ["dsa", "rsa", "ecdsa", "ed25519"]
    key_types.each { |type| `ssh-keygen -C "host key for #{host}" -q -N "" -t #{type} -f ssh_host_#{type}_key` }
  end

  desc "upload host keys to gcp (cloud storage for pub keys and secret manager for private keys)"
  task :upload_to_gcp do

    storage = Google::Cloud::Storage.new(
      project_id: "telvanni-platform",
      //TODO sort out auto magic auth
    )
  end

end
