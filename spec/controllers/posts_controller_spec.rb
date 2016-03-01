describe PostsController, :type => :controller do
  describe "GET #index" do
    it "populates an array of posts" do
      post = create(:post)
      get :index
      assigns(:posts).should eq([post])
    end
    it "renders the :index view" do
      get :index
      response.should render_template :index
    end

  end

  describe "GET #show" do

    it "assigns the requested post to @post" do
      post = create(:post)
      get :show, id: post
      assigns(:post).should eq(post)
    end

    it "renders the :show template" do
      get :show, id: create(:post)
      response.should render_template :show
    end

  end

  describe "GET #new" do
    it "assigns a new post to @post"
    it "renders the :new template"
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new post in the database"
      it "redirects to the home page"
    end

    context "with invalid attributes" do
      it "does not save the new post in the database"
      it "re-renders the :new template"
    end
  end
end
