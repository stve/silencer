module Silencer
  module Util
    def wrap(object)
      if object.nil?
        []
      elsif object.respond_to?(:to_ary)
        object.to_ary || [object]
      else
        [object]
      end
    end

    def extract_options!(args)
      if args.last.is_a?(Hash)
        args.pop
      else
        {}
      end
    end

    module_function :wrap, :extract_options!
  end
end
