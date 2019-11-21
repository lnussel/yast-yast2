# Copyright (c) [2019] SUSE LLC
#
# All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as published
# by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, contact SUSE LLC.
#
# To contact SUSE LLC about this file by physical or electronic mail, you may
# find current contact information at www.suse.com.

require_relative "../test_helper"
require "cfa/login_defs"

describe CFA::LoginDefs do
  subject(:login_defs) { described_class.new(file_path: file_path, file_handler: file_handler) }
  let(:file_path) { File.join(GENERAL_DATA_PATH, "login.defs", "vendor", "usr", "etc", "login.defs") }
  let(:file_handler) { File }

  before { login_defs.load }

  describe ".load" do
    it "loads the file content" do
      file = described_class.load(file_path: file_path, file_handler: file_handler)
      expect(file.loaded?).to eq(true)
    end
  end

  describe "#character_class" do
    it "returns the CHARACTER_CLASS value" do
      expect(login_defs.character_class).to include("ABCDEF")
    end
  end

  describe "#encrypt_method" do
    it "returns the ENCRYPT_METHOD" do
      expect(login_defs.encrypt_method).to eq("SHA512")
    end
  end

  describe "#fail_delay" do
    it "returns the FAIL_DELAY value" do
      expect(login_defs.fail_delay).to include("3")
    end
  end

  describe "#useradd_cmd" do
    it "returns the USERADD_CMD value" do
      expect(login_defs.useradd_cmd).to include("useradd.local")
    end
  end

  describe "#userdel_precmd" do
    it "returns the USERDEL_PRECMD value" do
      expect(login_defs.userdel_precmd).to include("userdel-pre.local")
    end
  end

  describe "#groupadd_cmd" do
    it "returns the GROUPADD_CMD value" do
      expect(login_defs.groupadd_cmd).to include("groupadd.local")
    end
  end
end
