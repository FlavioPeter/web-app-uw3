<template>
  <div>
    <stripe-checkout
      ref="checkoutRef"
      mode="payment"
      :pk="publishableKey"
      :line-items="lineItems"
      :success-url="successURL"
      :cancel-url="cancelURL"
      @loading="(v) => (loading = v)"
    />
    <button @click="submit">Pay now!</button>
  </div>
</template>
  
  <script>
import { StripeCheckout } from '@vue-stripe/vue-stripe'
import stripeConfig from '../../stripe-config'

export default {
  components: {
    StripeCheckout
  },
  data() {
    return {
      loading: false,
      publishableKey: stripeConfig.publishableKey,
      lineItems: [
        {
          price: 'price_1ODSPBBlCykkyYPdEEQjrcAO', // The id of the one-time price you created in your Stripe dashboard
          quantity: 3
        }
      ],
      successURL: 'http://localhost:5173/success',
      cancelURL: 'http://localhost:5173/error'
    }
  },
  methods: {
    submit() {
      // You will be redirected to Stripe's secure checkout page
      this.$refs.checkoutRef.redirectToCheckout()
    }
  }
}
</script>
  