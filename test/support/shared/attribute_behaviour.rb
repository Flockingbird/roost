# frozen_string_literal: true

##
# Shared behaviour for attribute-setters on an Aggregate
module AttributeBehaviour
  def self.included(base)
    base.extend(ClassMethods)
  end

  ##
  # Class-level it_* methods.
  module ClassMethods
    def it_behaves_as_attribute_setter(method, attribute, event)
      it_sets_attribute(method, attribute)
      it_sends_event_on_change(method, attribute, event)
      it_omits_event_on_no_change(method, attribute, event)
    end

    def it_sets_attribute(method, attribute)
      it "#{method} sets #{attribute}" do
        subject.send(method, attribute => 'to value')
        assert_equal(subject.send(attribute), 'to value')
      end
    end

    def it_sends_event_on_change(method, attribute, event)
      it "#{method} emits a #{event} when the bio changed" do
        subject.send(method, attribute => 'to value')
        assert_aggregate_has_event(event)
      end
    end

    def it_omits_event_on_no_change(method, attribute, event)
      it "#{method} does not emit a #{event} when the bio will not change" do
        subject.send(method, attribute => subject.send(attribute))
        refute_aggregate_has_event(event)
      end
    end
  end
end
