document.addEventListener('DOMContentLoaded', function () {
  fetchMenuItems()
    .then(displayMenuItems)
    .catch(displayFetchError);
});

function fetchMenuItems() {
  return window.fetch('http://localhost:4000/api', {
    method: 'POST',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      query: '{ menuItems { name } }'
    })
  }).then(function (response) {
    return response.json();
  });
}

function displayFetchError(response) {
  var element = document.createElement('p');
  element.innerHTML = 'Could not contact API';
  console.error("Fetch Error", response);
  document.body.appendChild(element);
}

function displayMenuItems(result) {
  var element;

  if (result.errors) {
    var element = document.createElement('p');
    element.innerHTML = 'Could not retrieve menu items.';
    console.error("GraphQL Errors", result.errors)
  } else if (result.data.menuItems) {
    var element = document.createElement('ul');
    result.data.menuItems.forEach(function (item) {
      var itemElement = document.createElement('li');
      itemElement.innerHTML = item.name;
      element.appendChild(itemElement);
    });
    document.body.appendChild(element);
  }
}
