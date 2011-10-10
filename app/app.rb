class CloudConsole < Padrino::Application
  register ScssInitializer
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  enable :sessions

  @@connection = Fog::Compute.new({
    :provider                 => 'AWS',
    :aws_access_key_id        => 'YOUR_ACCESS_KEY',
    :aws_secret_access_key    => 'YOUR_SECRET_KEY'
  })


  def self.aws_connection
    @@connection
  end


  def self.aws_servers
    @@connection.servers
  end

  get :about, :map => '/sobre' do
    render :haml, "%p Este eh um trabalho de implementacao para a disciplina Ambientes de Desenvolvimento de Software da turma 13 do Mestrado em Informatica Aplicada - UNIFOR."
  end
end
