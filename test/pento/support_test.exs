defmodule Pento.SupportTest do
  use Pento.DataCase

  alias Pento.Support

  describe "faqs" do
    alias Pento.Support.FAQ

    @valid_attrs %{answer: "some answer", question: "some question", vote_count: 42}
    @update_attrs %{answer: "some updated answer", question: "some updated question", vote_count: 43}
    @invalid_attrs %{answer: nil, question: nil, vote_count: nil}

    def faq_fixture(attrs \\ %{}) do
      {:ok, faq} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Support.create_faq()

      faq
    end

    test "list_faqs/0 returns all faqs" do
      faq = faq_fixture()
      assert Support.list_faqs() == [faq]
    end

    test "get_faq!/1 returns the faq with given id" do
      faq = faq_fixture()
      assert Support.get_faq!(faq.id) == faq
    end

    test "create_faq/1 with valid data creates a faq" do
      assert {:ok, %FAQ{} = faq} = Support.create_faq(@valid_attrs)
      assert faq.answer == "some answer"
      assert faq.question == "some question"
      assert faq.vote_count == 42
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Support.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      faq = faq_fixture()
      assert {:ok, %FAQ{} = faq} = Support.update_faq(faq, @update_attrs)
      assert faq.answer == "some updated answer"
      assert faq.question == "some updated question"
      assert faq.vote_count == 43
    end

    test "update_faq/2 with invalid data returns error changeset" do
      faq = faq_fixture()
      assert {:error, %Ecto.Changeset{}} = Support.update_faq(faq, @invalid_attrs)
      assert faq == Support.get_faq!(faq.id)
    end

    test "delete_faq/1 deletes the faq" do
      faq = faq_fixture()
      assert {:ok, %FAQ{}} = Support.delete_faq(faq)
      assert_raise Ecto.NoResultsError, fn -> Support.get_faq!(faq.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      faq = faq_fixture()
      assert %Ecto.Changeset{} = Support.change_faq(faq)
    end
  end
end
