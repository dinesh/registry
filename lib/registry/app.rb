
require 'sinatra'
require 'sinatra/sequel'
require 'json'
require 'aws/s3'

require_relative 'migrations'

module Registry
  class App < Sinatra::Base

      set :protection, false
      set :public_folder, "#{File.dirname(__FILE__)}/../../assets"
      set :views, "#{Config.root}/views"

      set :bucket,    Config.s3_bucket
      set :s3_key,    Config.s3_key
      set :s3_secret, Config.s3_secret

      configure do
        enable :logging, :dump_errors, :raise_errors, :show_exceptions
        use Rack::CommonLogger
        set :database, Config.database_url
        Sequel.connect(settings.database)
      end

      get '/' do
        erb :home
      end

      get '/companies' do
        content_type :json
        Company.all.map{|c| c.values }.to_json
      end

      post '/companies' do
        halt(404) unless raw['company']
        company = Company.new(raw['company'])
        begin
          company.save
        rescue Sequel::ValidationFailed
          halt 500, company.errors.to_json
        end
        company.values.to_json
      end

      put '/companies/:id' do
        company = Company.find params[:id]
        raw['company'].delete('id')
        begin
          company.update(raw['company'])
          company.values.to_json
        rescue Sequel::ValidationFailed
          halt 500, company.errors.to_json
        end
      end

      get '/companies/:id' do
        company = Company.find(params[:id])
        company.values.to_json
      end

      get '/owners' do
        owners = Owner.filter(company_id: params[:company_id])
        owners.map{|owner| owner_to_json(owner) }.to_json
      end

      post '/owners' do
        id, name , company_id = params['id'], params['name'], params['company_id']
        qqfile = upload_file(params)
        filename = sanitize_filename(qqfile[:name])

        attributes = { name: name, company_id: company_id, passport_file_name: filename, passport_content_type: qqfile[:type] }
        logger.info "id: #{id}, attributes: #{attributes}"

        owner = id ? Owner.find(id) : Owner.new(attributes)

        begin
            id ? owner.update(attributes) : owner.save
            { success: true }.to_json
          rescue Sequel::ValidationFailed
            halt 404, { errors: owner.errors }.to_json
          end
      end

      private

      def raw
        @raw ||= JSON.parse(request.body.read)
      end

      def owner_to_json o
        {
          :id      => o.id,
          :name    =>  o.name,
          :passport_file_name => s3_file_url(o.passport_file_name)
        }
      end

      def sanitize_filename(filename)
        fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
        fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }
        fn.join '.'
      end

      def s3_file_url key
        "http://s3.amazonaws.com/#{settings.bucket}/#{key}"
      end

      def upload_file params
        passport_param = params.select{|k,v| v.kind_of?(Hash) && v[:tempfile] }.first

        if passport_param && qqfile = passport_param[1]
          filename, tmpfile = sanitize_filename(qqfile[:name]), qqfile[:tempfile]
          s3 = AWS::S3.new(:access_key_id => settings.s3_key, :secret_access_key => settings.s3_secret)
          bucket = s3.buckets[settings.bucket]

          unless bucket.exists?
            s3.buckets.create(settings.bucket)
          end
          bucket.objects[filename].write(tmpfile, :acl => :public_read)
          qqfile

        else
          halt 404, 'passwort file seems empty'
        end
      end

  end
end