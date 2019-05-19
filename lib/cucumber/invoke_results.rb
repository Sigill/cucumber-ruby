module Cucumber
  class InvokeResult
    attr_reader :params
    def initialize(params)
      @params = params
    end

    def embeddings
      return [] if params.nil?
      return @params['embeddings'] || []
    end
  end

  class PassedInvokeResult < InvokeResult
    def to_result(duration)
      Cucumber::Core::Test::Result::Passed.new(duration, embeddings())
    end
  end

  class FailedInvokeResult < InvokeResult
    attr_reader :exception
    def initialize(params, exception)
      super(params)
      @exception = exception
    end

    def to_result(duration)
      Cucumber::Core::Test::Result::Failed.new(duration, @exception, embeddings())
    end
  end

  class PendingInvokeResult < InvokeResult
    attr_reader :message
    def initialize(params)
      super(params)
      @message = params
    end

    def to_result(duration)
      Pending.new(@message).with_duration(duration)
    end
  end
end
