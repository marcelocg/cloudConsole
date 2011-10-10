CloudConsole.controllers :console do

  get :index do
    @servers = CloudConsole.aws_servers.all
    render 'console/index'
  end

  post :add do

    name = params[:instance_name]

    image_id = case params[:image]
      when 'Tracks'
        'ami-50897239'
      when 'Redmine'
        'ami-41e92d28'
    end

    @server = CloudConsole.aws_servers.create(:key_name => 'mcg', :image_id => image_id, :tags => {'Name' => name, 'App' => params[:image].downcase})
    @server.wait_for { ready? }

    redirect url(:console, :index)
  end

  get :run, :with => :id do
    server = CloudConsole.aws_servers.get(params[:id])
    server.start
    server.wait_for{ ready? }
    redirect url_for(:console, :index)
  end

  get :stop, :with => :id do
    server = CloudConsole.aws_servers.get(params[:id])
    server.stop
    server.wait_for{ state == 'stopped' }
    redirect url_for(:console, :index)
  end

  get :terminate, :with => :id do
    server = CloudConsole.aws_servers.get(params[:id])
    server.destroy
    server.wait_for{ state == 'terminated' }
    redirect url_for(:console, :index)
  end
end
