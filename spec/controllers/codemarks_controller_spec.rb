require 'spec_helper'

describe CodemarksController do
  describe "build_linkmark" do
    let(:valid_url) { "http://www.example.com" }
    let(:resource_attrs) { { "url" => valid_url } }

    it "asks for a prepared codemark" do
      Codemark.should_receive(:prepare).with(:link, resource_attrs)
      get :build_linkmark, :format  => :js, :resource_attrs => resource_attrs
    end

    it "creates a new codemark with the new link" do
      codemark = stub
      Codemark.stub(:prepare) { codemark }

      get :build_linkmark, format: "js"
      assigns(:codemark).should == codemark
    end

    it "link has an invalid_url if it is a nonsense url" do
      get :build_linkmark, format: "js", :resource_attrs => {url: "http://thisshouldntblowup"}
      assigns(:codemark).resource.should_not be_valid_url
    end

    it "link has an invalid_url if no url is provided" do
      get :build_linkmark, format: "js", :resource_attrs => {}
      assigns(:codemark).resource.should_not be_valid_url
    end
  end

  describe "#create" do
    it "creates a codemark" do
      codemark_attrs = {}
      resource_attrs = {}
      tags = {}
      user = stub
      controller.stub!(:current_user => user)

      Codemark.should_receive(:create).with(codemark_attrs, resource_attrs, [], user, :new_topic_titles => nil)
      @request.env['HTTP_REFERER'] = 'http://localhost:3000/dashboard'
      post :create, :format => :js, :codemark_attrs => codemark_attrs, :resource_attrs => resource_attrs, :tags => tags
    end
  end

  describe "#public" do
    it "calls FindCodemarks" do
      codemarks = []
      finder = stub(:codemarks => codemarks)
      FindCodemarks.should_receive(:new).and_return(finder)
      get :public
    end

    it "it assigns codemarks" do
      codemarks = []
      finder = stub(:codemarks => codemarks)
      FindCodemarks.stub!(:new => finder)
      get :public
      assigns[:codemarks].should == codemarks
    end
  end
end

#    it "creates a new codemark" do
#      send @method, @action, @params
#      assigns(:new_codemark).should be_kind_of(Codemark)
#    end
#
#    context "new url" do
#      it "makes a new link" do
#        send @method, @action, @params
#        controller.params.should include(:action)
#        controller.params.should include(:url)
#        assigns(:new_codemark).link.should be_kind_of(Link)
#        assigns(:new_codemark).link.should be_new_record
#        assigns(:new_codemark).link.url.should == "http://www.google.com"
#      end
#
#      it "makes the link a smart link" do
#        send @method, @action, @params
#        assigns(:new_codemark).link.title.should == "Google"
#      end
#    end
#
#    it "finds matches a link if one exists already" do
#      link = Fabricate(:link, url: "http://www.google.com")
#      send @method, @action, @params
#      assigns(:new_codemark).link.should == link
#    end
#
#    it "fetches the topics based on the link" do
#      google = Fabricate(:topic, title: "google")
#      link = Fabricate.build(:link, url: "http://www.google.com")
#      send @method, @action, @params
#      assigns(:new_codemark).topics.should include(google)
#    end
#  end
#  context "#edit" do
#    it "works" do
#      codemark = Fabricate(:codemark)
#      get :edit, id: codemark.id
#      response.should be_successful
#    end
#  end
#end
