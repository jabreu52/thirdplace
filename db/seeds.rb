puts "CREATE COMMUNITIES"

@gender = %W[ Male Female ]
@degree = %W[ Associate's Bachelor's Master's Doctoral #{"Pursuing Associate's"} #{"Pursuing Bachelor's"}
  #{"Pursuing Master's"} #{"Pursuing Doctoral"} #{"High School"} ]
@standing = %W[ Alumni #{'Graduate Student'} Undergraduate ]
@school = %W[ #{'Yale University'} #{'Harvard University'} #{'Cornell University'} #{'Brown University'} #{'Massachusetts Institute of Technology'} #{'Rutgers University'}]
@field = %W[ #{'Political Science'} Education Medicine Law]

%w( gender degree standing school field ).each do |type|
  instance_variable_get("@#{type}").each do |name|
    type.capitalize.constantize.create name: name, slug: name.parameterize
  end
end

4.times do
  Company.create name: Faker::Company.name
end

puts "CREATE USERS"
200.times do
  User.create(
    email: Faker::Internet.email,
    password: Devise.friendly_token[0,20],
    name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    image: "http://graph.facebook.com/#{rand(300000..302715)}/picture?type=large",
    communities: [Community.all.sample, Gender.all.sample, Degree.all.sample, Standing.all.sample, School.all.sample, Field.all.sample, Company.all.sample]
  )
end
