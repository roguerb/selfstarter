require 'spec_helper'

describe Order do
  it { should belong_to :user }

  describe "lifecycle callbacks" do
    context "An unsaved new Order" do
      subject { Order.new }
      its(:uuid) { should be_nil }
    end

    context "A newly created Order" do
      subject { Order.create }
      its(:uuid) { should be_present }
    end

    context "when an Order already exists with a uuid" do
      let(:valid_params) {
        {
          name: "Name",
          price: 5.0,
          user_id: User.create(email: "foo@bar.com").id
        }
      }
      let(:previous_order) { Order.prefill!(valid_params) }
      it "should not allow the same uuid" do
        SecureRandom.should_receive(:hex).with(16).and_return(previous_order.uuid, "something else")
        expect { Order.prefill!(valid_params) }.to_not raise_error
      end
    end
  end
end
