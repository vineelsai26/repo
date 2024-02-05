import os
import requests

response = requests.get('https://api.github.com/repos/python/cpython/git/matching-refs/tags/v')

data = [str(tag["ref"]).replace('refs/tags/v', '') for tag in response.json()]


def version_data(versions):
	for i in data:
		append = True
		for j in i.split('.'):
			if j.isdigit():
				continue
			else:
				append = False
				break
		if append:
			versions.append(i)

	versions.reverse()

versions = []
version_data(versions)

os.makedirs('build', exist_ok=True)

# for version in versions:
# 	if os.path.exists(f'build/Python-{version}.tgz'):
# 		print(f"Python {version} already downloaded!")

# 		if os.path.exists(f'build/Python-{version}'):
# 			print(f"Python {version} already extracted!")
# 		else:
# 			os.system(f'tar -xvf build/Python-{version}.tgz -C build/')
# 		continue

# 	print(f"Downloading Python {version}...")
# 	url = f'https://www.python.org/ftp/python/{version}/Python-{version}.tgz'
# 	response = requests.get(url)
# 	with open(f'build/Python-{version}.tgz', 'wb') as f:
# 		f.write(response.content)
# 	print(f"Downloaded Python {version}!")

# 	os.system(f'tar -xvf build/Python-{version}.tgz -C build/')

for version in versions:
	os.chdir(f'build/Python-{version}')
	os.system('./configure --prefix=usr --enable-optimizations --enable-shared --with-computed-gotos --with-lto --enable-ipv6 --enable-loadable-sqlite-extensions')
	os.system('make -j$(nproc)')
	os.system(f'make DESTDIR="$usr/bin/{version}" altinstall')
