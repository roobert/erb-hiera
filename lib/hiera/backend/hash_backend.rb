class Hiera
  module Backend
    class Hash_backend
      def initialize(cache=nil)
        Hiera.debug("Hiera Hash backend starting")
      end

      def lookup(key, scope, order_override, resolution_type, context)
        answer = nil
        found = false

        Hiera.debug("Looking up #{key} in Hash backend")

        throw :no_such_key unless ErbHiera.options[:variables_given]

        data = JSON.load(ErbHiera.options[:variables])

        throw :no_such_key unless data.include?(key)
        found = true

        # Extra logging that we found the key. This can be outputted
        # multiple times if the resolution type is array or hash but that
        # should be expected as the logging will then tell the user ALL the
        # places where the key is found.
        Hiera.debug("Found #{key} in Hash backend")

        # for array resolution we just append to the array whatever
        # we find, we then goes onto the next file and keep adding to
        # the array
        #
        # for priority searches we break after the first found data item
        new_answer = Backend.parse_answer(data[key], scope, {}, context)
        case resolution_type.is_a?(Hash) ? :hash : resolution_type
        when :array
          raise Exception, "Hiera type mismatch for key '#{key}': expected Array and got #{new_answer.class}" unless new_answer.kind_of? Array or new_answer.kind_of? String
          answer ||= []
          answer << new_answer
        when :hash
          raise Exception, "Hiera type mismatch for key '#{key}': expected Hash and got #{new_answer.class}" unless new_answer.kind_of? Hash
          answer ||= {}
          answer = Backend.merge_answer(new_answer, answer, resolution_type)
        else
          answer = new_answer
          return answer
        end

        throw :no_such_key unless found
        return answer
      end
    end
  end
end
