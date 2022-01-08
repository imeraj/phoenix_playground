defmodule PentoWeb.ProductLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       auto_upload: false,
       progress: &handle_progress/3
     )}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  def update_changeset(%{assigns: %{changeset: changeset}} = socket, key, value) do
    socket |> assign(:changeset, Ecto.Changeset.put_change(changeset, key, value))
  end

  defp save_product(socket, :edit, product_params) do
    product_params =
      Map.put(
        product_params,
        "image_upload",
        Map.get(
          socket.assigns.changeset.changes,
          :image_upload,
          socket.assigns.product.image_upload
        )
      )

    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    product_params =
      Map.put(
        product_params,
        "image_upload",
        Map.get(socket.assigns.changeset.changes, :image_upload, "")
      )

    case Catalog.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp handle_progress(:image, entry, socket) do
    if entry.done? do
      path = consume_uploaded_entry(socket, entry, &upload_static_file(&1, socket))

      {:noreply,
       socket
       |> put_flash(:info, "file #{entry.client_name} uploaded")
       |> update_changeset(:image_upload, path)}
    else
      {:noreply, socket}
    end
  end

  defp upload_static_file(%{path: path}, socket) do
    # Plug in your production image file persistence implementation here

    dest = Path.join("priv/static/images", Path.basename(path))
    File.cp!(path, dest)
    Routes.static_path(socket, "/images/#{Path.basename(dest)}")
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
