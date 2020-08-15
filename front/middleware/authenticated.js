export default function({ store, redirect }) {
  if (!store.state.isLoggedIn) {
    return redirect("/")
  }
}
