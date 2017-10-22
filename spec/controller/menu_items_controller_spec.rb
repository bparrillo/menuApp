require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  before do
    allow(subject).to receive(:authenticate_user!).and_return(User.first)
    item=MenuItem.new(name: "salad", description: "bad", price: 2, category: "dessert")
    item.save
    item2=MenuItem.new(name: "cake", description: "good", price: 13, category: "dessert")
    item2.save
  end

  it "updates" do
    put 'update', params: { menu_item: { category: "appetizer" }, id: 1}
    expect(MenuItem.find(1).category).to eq("appetizer")
  end

  it "gets responses" do
    get 'new'
    expect(response).to be_success

    get 'show', params: { id: 1 }
    expect(response).to be_success

    get 'index'
    expect(response).to be_success

    get 'index'
    expect(response).to be_success

    get 'submit_order'
    expect(response).to be_success
  end

  it "shows correct sum" do
    get 'confirm_order', params: { "1" => 2, "2" => 3}
    expect(assigns(:sum)).to eq(43)
  end

  it "creates order" do
    post 'finalize_order', params: { order: {"1" => 2, "2" => 3}}
    expect(Order.first.menu_items).to eq([MenuItem.first, MenuItem.second])
    expect(OrderItem.first.number).to eq(2)
    expect(OrderItem.second.number).to eq(3)
  end
end
