def find_item_by_name_in_collection(name, collection)
  i = 0
  while i < collection.length do
    if collection[i][:item] == name
      return collection[i]
    end
    i += 1
  end
end

  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.

def consolidate_cart(cart)
  updated_cart = []
  i = 0
  while i < cart.length do
    updated_cart_item = find_item_by_name_in_collection(cart[i][:item], updated_cart)
    if updated_cart_item #if it does have a value
      updated_cart_item[:count] += 1
    else
      updated_cart_item = {
        :item => cart[i][:item],
        :price => cart[i][:price],
        :clearance => cart[i][:clearance],
        :count => 1
      }
      updated_cart << updated_cart_item
    end
    i += 1
  end
  updated_cart
end

def apply_coupons(cart, coupons)
  i = 0
  while i < coupons.length do
    cart_item = find_item_by_name_in_collection(coupons[i][:item], cart)
    couponed_item_name = "#{coupons[i][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
    if cart_item && cart_item[:count] >= coupons[i][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[i][:num]
        cart_item[:count] -= coupons[i][:num]
      else
        cart_item_with_coupon = {
          :item => couponed_item_name,
          :price => coupons[i][:cost] / coupons[i][:num],
          :clearance => cart_item[:clearance],
          :count => coupons[i][:num]
          }
          cart << cart_item_with_coupon
          cart_item[:count] -= coupons[i][:num]
      end
    end
    i += 1
  end
  cart
end

def apply_clearance(cart)
  i = 0
  while i < cart.length do
    if cart[i][:clearance]
      cart[i][:price] = (cart[i][:price] - (cart[i][:price] * 0.20)).round(2)
    end
    i += 1
  end
  cart
end


  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers

def checkout(cart, coupons)
  new_consolidated_cart = consolidate_cart(cart)
  cart_with_coupons_applied = apply_coupons(new_consolidated_cart, coupons)
  cart_with_all_discounts_applied = apply_clearance(cart_with_coupons_applied)
  i = 0
  total = 0
  while i < cart_with_all_discounts_applied.length do
    total += cart_with_all_discounts_applied[i][:count] * cart_with_all_discounts_applied[i][:price]
    i += 1
  end
  if total > 100
    total = (total - (total * 0.10)).round(2)
  end
  total
end