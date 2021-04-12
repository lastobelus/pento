defmodule Pento.Accounts.UserNotifier do
  import Bamboo.Email
  alias Pento.Mailer

  @from_address "pento@example.com"

  defp deliver(to, subject, text_body, html_body) do
    email =
      new_email(
        to: to,
        from: @from_address,
        subject: subject,
        text_body: text_body,
        html_body: html_body
      )
      |> Mailer.deliver_now()

    email
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    text_body = """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """

    html_body = """
    Hi #{user.email},<br/><br/>
    You can confirm your account by visiting the URL below:<br/><br/>
    <a href="#{url}" target="_blank">#{url}</a><br/><br/>
    If you didn't create an account with us, please ignore this.
    """

    deliver(user.email, "Please confirm your account", text_body, html_body)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    text_body = """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

    html_body = """
    Hi #{user.email},<br/><br/>
    You can reset your password by visiting the URL below:<br/><br/>
    <a href="#{url}" target="_blank">#{url}</a><br/><br/>
    If you didn't request this change, please ignore this.
    """

    deliver(user.email, "Password reset request", text_body, html_body)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    text_body = """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """

        html_body = """
    Hi #{user.email},<br/><br/>
    You can change your email by visiting the URL below:<br/><br/>
    <a href="#{url}" target="_blank">#{url}</a><br/><br/>
    If you didn't request this change, please ignore this.
    """

    deliver(user.email, "Email update request", text_body, html_body)
  end
end
