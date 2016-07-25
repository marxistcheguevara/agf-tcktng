require 'test_helper'

class TicketItemsControllerTest < ActionController::TestCase
  setup do
    @ticket_item = ticket_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ticket_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ticket_item" do
    assert_difference('TicketItem.count') do
      post :create, ticket_item: {  }
    end

    assert_redirected_to ticket_item_path(assigns(:ticket_item))
  end

  test "should show ticket_item" do
    get :show, id: @ticket_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ticket_item
    assert_response :success
  end

  test "should update ticket_item" do
    patch :update, id: @ticket_item, ticket_item: {  }
    assert_redirected_to ticket_item_path(assigns(:ticket_item))
  end

  test "should destroy ticket_item" do
    assert_difference('TicketItem.count', -1) do
      delete :destroy, id: @ticket_item
    end

    assert_redirected_to ticket_items_path
  end
end
