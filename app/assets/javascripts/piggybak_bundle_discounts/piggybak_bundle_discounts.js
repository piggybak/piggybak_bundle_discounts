$(function(){
	$(document).ready(function() {
		piggybak_bundle_discounts.apply_bundle_discount();
	});
	
});

var piggybak_bundle_discounts = {
	apply_bundle_discount: function() {
		$.ajax({
			url: bundle_discount_lookup,
			cached: false,
			dataType: "JSON",
			success: function(data) {
				if(data.bundle_discount) {
					//Add valid bundle discount line items
					//Append visual bundle discount line item to totals
					//update totals
					$("#bundle_discount_total").html('-$' + (parseFloat(data.amount)).toFixed(2));
					$("#bundle_discount_row").show();
					piggybak.update_totals();
				} else {
					if($('#coupon_code').val() != '') {
						$('#coupon_response').html(data.message).show();
					}
					$('#coupon_application_total').html('$0.00');
					$('#coupon_application_row').hide();
					piggybak.update_totals();
				}
			}
		});
	}	
};




