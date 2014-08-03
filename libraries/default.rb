require 'chef/resource'

class Chef
  class Resource
    class Backstop < Chef::Resource
      def initialize(name, run_context=nil)
        super
        @resource_name = :backstop
        @provider = nil # Seems we don't even need a provider
        @action = :nothing
        @allowed_actions.push(:execute)
        @queue = Hash.new
      end

      def run_action(action, notification_type=nil, notifying_resource=nil)
        if(action.class == Hash)
          (@queue[resources(action[:resource])] ||= []) << action[:action]
        else
          if(action == :execute)
            @queue.each_pair { |k,v|
              v.uniq.each { |a|
                self.notifies(a, k, :immediate)
              }
            }
            self.updated_by_last_action(true)
          else
              super
          end
        end
      end
    end
  end
end
