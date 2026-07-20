document.addEventListener('DOMContentLoaded', function () {
  var abc = document.querySelector('.btnstyle');
  if (!abc) return;

  abc.addEventListener('click', function (event) {
    event.preventDefault();
    alert('您已將商品加入購物車');

    if (typeof gtag === 'function') {
      gtag('event', 'add_shipping_info', {
        currency: '新台幣',
        value: 1234,
        coupon: 'SUMMER_FUN',
        shipping_tier: 'Ground',
        items: [
          {
            item_id: 'SKU_12345',
            item_name: 'Stan and Friends Tee',
            affiliation: 'Google Merchandise Store',
            coupon: 'SUMMER_FUN',
            discount: 2.22,
            index: 0,
            item_brand: 'Google',
            item_category: 'Apparel',
            item_category2: 'Adult',
            item_category3: 'Shirts',
            item_category4: 'Crew',
            item_category5: 'Short sleeve',
            item_list_id: 'related_products',
            item_list_name: 'Related Products',
            item_variant: 'green',
            location_id: 'ChIJIQBpAG2ahYAR_6128GcTUEo',
            price: 10.01,
            google_business_vertical: 'retail',
            quantity: 3
          }
        ]
      });
    }
  }, false);
});
