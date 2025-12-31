# This migration seeds the Partner table with major partner logos and names for homepage display
class SeedMajorPartners < ActiveRecord::Migration[6.1]
  def up
    partners = [
      {
        name: "Google for Startups",
        logo_url: "https://www.gstatic.com/images/branding/googlelogo/svg/googlelogo_clr_74x24px.svg"
      },
      {
        name: "Microsoft for Startups",
        logo_url: "https://learn.microsoft.com/en-us/microsoft-for-startups/media/microsoft-for-startups-badge.png"
      },
      {
        name: "Y Combinator",
        logo_url: "https://www.ycombinator.com/images/ycombinator-logo.svg"
      },
      {
        name: "African Development Bank",
        logo_url: "https://www.afdb.org/sites/default/files/styles/logo/public/logo_afdb_en.svg"
      },
      {
        name: "World Bank",
        logo_url: "https://www.worldbank.org/content/dam/wbr/logo/wbg-logo-svg.svg"
      },
      {
        name: "IFC",
        logo_url: "https://www.ifc.org/wps/wcm/connect/corp_ext_content/ifc_external_corporate_site/ifc+logo/ifc_logo.svg"
      }
    ]
    partners.each_with_index do |attrs, i|
      Partner.create!(attrs.merge(active: true, display_order: i+1))
    end
  end

  def down
    names = [
      "Google for Startups",
      "Microsoft for Startups",
      "Y Combinator",
      "African Development Bank",
      "World Bank",
      "IFC"
    ]
    Partner.where(name: names).delete_all
  end
end
