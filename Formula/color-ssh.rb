class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.9.1/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "862fa5da54aa462355abe059e4c37d5bd7b5138a5494c98a11a1e14036e53573"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.9.1/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "77917442113c38af63a78248e399baf6a81cc2e039fc08eab6d9aaa827830654"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.9.1/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "811ee706407716d3ff2e7e5bf225ad57d241bf88c8de1defc12ceb14d5c07866"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.9.1/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19cde91b6045b2706da1aa56b5accc674558027fcc494faac93b43bb1c8ce048"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cossh" if OS.mac? && Hardware::CPU.arm?
    bin.install "cossh" if OS.mac? && Hardware::CPU.intel?
    bin.install "cossh" if OS.linux? && Hardware::CPU.arm?
    bin.install "cossh" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
