# frozen_string_literal: true

require "bundler/setup"
require "standard/rake"

$LOAD_PATH.unshift(__dir__ + "/lib")
Dir.glob("./tasks/*.{rake,rb}").each { |f| import f }

task default: ["standard:fix"]
