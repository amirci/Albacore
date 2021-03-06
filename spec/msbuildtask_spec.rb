require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'albacore/msbuild'
require 'rake/msbuildtask'
require 'fail_patch'

describe "when running" do
  before :all do
    msbuild :msbuild do |t|
      t.extend(FailPatch)
      @yielded_object = t
    end
    Rake::Task[:msbuild].invoke
  end
  
  it "should yield the msbuild api" do
    @yielded_object.kind_of?(MSBuild).should == true 
  end
end

describe "when execution fails" do
  before :all do
    msbuild :msbuild_fail do |t|
      t.extend(FailPatch)
      t.fail
    end
    Rake::Task[:msbuild_fail].invoke
  end
  
  it "should fail the rake task" do
    $task_failed.should == true
  end
end

describe "when task args are used" do
  before :all do
    msbuild :msbuildtask_withargs, [:arg1] do |t, args|
      t.extend(FailPatch)
      @args = args
  	end
    Rake::Task[:msbuildtask_withargs].invoke("test")
  end
  
  it "should provide the task args" do
    @args.arg1.should == "test"
  end
end
