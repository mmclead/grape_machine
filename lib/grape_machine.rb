require 'grape'

require "grape_machine/version"


module GrapeMachine
  def self.included(base)
    base.class_eval do
      #class method to add endpoints
      def self.add_grape_machine_endpoints(klass, instance_name)
        state_machine_event_names_for(klass).each do |event_name|
          desc "#{event_name} a #{klass.name}"
          put event_name.to_sym do
            instance_variable_get("@#{instance_name.to_sym}").tap{|instance| instance.send("#{event_name}!")}
          end
        end
      end

      def self.state_machine_event_names_for(klass)
        klass.aasm.events.map(&:name)
      end
    end
  end
end

Grape::API.send(:include, GrapeMachine)
