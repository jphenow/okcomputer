require 'spec_helper'

describe OkComputerController do
  describe "GET 'index'" do
    let(:checks) do
      stub(:all_checks, {
        to_text: "text of the results",
        to_json: "json of the results",
        success?: nil,
      })
    end

    before do
      OKComputer::Registry.stub(:all) { checks }
    end

    it "performs the basic up check" do
      get :index, format: :text
      response.body.should == checks.to_text
    end

    it "performs the basic up check as JSON" do
      get :index, format: :json
      response.body.should == checks.to_json
    end

    it "returns a failure status code if any check fails" do
      checks.stub(:success?) { false }
      get :index, format: :text
      response.should_not be_success
    end

    it "returns a success status code if all checks pass" do
      checks.stub(:success?) { true }
      get :index, format: :text
      response.should be_success
    end
  end

  describe "GET 'show'" do
    let(:check_type) { "basic" }
    let(:check) do
      stub(:single_check, {
        to_text: "text of check",
        to_json: "json of check",
        success?: nil,
      })
    end

    before do
      OKComputer::Registry.should_receive(:fetch).with(check_type) { check }
    end

    it "performs the given check and returns text" do
      get :show, check: check_type, format: :text
      response.body.should == check.to_text
    end

    it "performs the given check and returns JSON" do
      get :show, check: check_type, format: :json
      response.body.should == check.to_json
    end

    it "returns a success status code if the check passes" do
      check.stub(:success?) { true }
      get :show, check: check_type, format: :text
      response.should be_success
    end

    it "returns a failure status code if the check fails" do
      check.stub(:success?) { false }
      get :show, check: check_type, format: :text
      response.should_not be_success
    end

    it "returns a failure status code if given a status check not already registered"
  end
end
