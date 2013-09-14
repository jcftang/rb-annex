require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Annex do
  it "should create an object" do
    @object = Annex::Key.new
    @object.should be_valid
  end

  it "should generate a key with sha256" do
    # http://git-annex.branchable.com/internals/key_format/
    @object = Annex::Key.new
    file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
    hash = "sha256"
    @object.gen_key(hash, file_location)
    @object.hash_alg.should include("sha256")
    @object.hash.length.should == 64
    @object.annex_key.should == "SHA256-s127660--35ac3cf3fdb1a3bf5c0930ad0a45f1eae36ea3c2f2837e68965241fcbe1d0ba7"
  end

  it "should generate a key with worm" do
    # http://git-annex.branchable.com/internals/key_format/
    @object = Annex::Key.new
    file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
    hash = "worm"
    @object.gen_key(hash, file_location)
    @object.hash_alg.should include("worm")
    @object.hash.length.should == 36
    @object.annex_key.should include "WORM"
  end

  it "should return the location of where to store the key" do
    # see http://git-annex.branchable.com/internals/hashing/
    @object = Annex::Key.new
    file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
    hash = "sha256"
    @object.gen_key(hash, file_location)
    @object.get_annex_hash(@object.annex_key)
    @object.annex_hash.should == "f204a97eeb5e39d3bc4edd0e1ed61154"
    @object.annex_hash_1.should == "f20"
    @object.annex_hash_2.should == "4a9"
  end
end
