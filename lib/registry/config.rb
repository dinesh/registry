module Registry
  module Config
    extend self

    def database_url
      ENV['DATABASE_URL'] || 'sqlite://test.db'
    end

    def development?
      ENV["RACK_ENV"] == "development"
    end

    def production?
      ENV["RACK_ENV"] == "production"
    end

    def release
      @release ||= ENV["RELEASE"] || "1"
    end

    def s3_bucket
      ENV['AWS_BUCKET'] || "minibar-prod/registry-#{ENV['RACK_ENV']}"
    end

    def s3_key
      ENV['AWS_ACCESS_KEY'] || raise("missing=AWS_ACCESS_KEY")
    end

    def s3_secret
      ENV['AWS_SECRET_KEY'] || raise("missing=AWS_SECRET_KEY")
    end

    def root
      @root ||= File.expand_path("../../../", __FILE__)
    end
  end
end
