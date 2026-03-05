class ColorSsh < Formula
  desc "A Rust-based SSH client with syntax highlighting."
  homepage "https://github.com/karsyboy/color-ssh"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.8.1/color-ssh-aarch64-apple-darwin.tar.xz"
      sha256 "41654e554d7e2455d219264caa1bc45e67a1ff9f9a3f5ebd6c6118819f9fa142"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.8.1/color-ssh-x86_64-apple-darwin.tar.xz"
      sha256 "408fc197e480a87170ca848f3b32842007b6a52398259b63ef0812b5fde7b59b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.8.1/color-ssh-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "723d1b6cc193c1b284620396f4ae915bdab869f8b00e391e2a77e381ee82d0d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/karsyboy/color-ssh/releases/download/v0.8.1/color-ssh-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fba33ae5148dedb4cb0294ff16a6abe8111f5b8f8d5c3e1bb087ab22b93388f6"
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
