RSpec::Matchers.define :have_version do |major, minor, patch|
  match do |helper|
    helper.major == major &&
      helper.minor == minor &&
      helper.patch == patch &&
      helper.to_s == [major, minor, patch].compact.join('.')
  end
end

RSpec::Matchers.define :have_build_version do |major, minor, patch, build|
  match do |helper|
    helper.major == major &&
      helper.minor == minor &&
      helper.patch == patch &&
      helper.build == build &&
      helper.to_s == [major, minor, patch, build].compact.join('.')
  end
end
