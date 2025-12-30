import Dropdown from "@stimulus-components/dropdown"

export default class extends Dropdown {
  connect() {
    super.connect()
    console.log("Custom dropdown connected.")
  }
}
